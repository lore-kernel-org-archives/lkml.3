Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab3CLTIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:08:35 -0400
Received: from mail1-ar.fullrate.dk ([90.185.0.67]:64125 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932680Ab3CLTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:08:34 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 15:08:34 EDT
Message-ID: <513F7AB3.3@molgaard.org>
Date: Tue, 12 Mar 2013 19:57:55 +0100
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [bisected] nouveau failure with 3.9-rc1 and ongoing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya,

Between 3.8 and 3.9-rc1, the following occurs:

Upon boot, when KMS kicks in, I get a blank screen. Keyboard responds 
correctly to "Num Lock" on/off, but machine is unreachable on the network.

Git bisection says:

eb6313add6dddf07ea3e50c4caa33a9c3b2379f1 is the first bad commit
commit eb6313add6dddf07ea3e50c4caa33a9c3b2379f1
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Feb 11 09:52:58 2013 +1000

     drm/nv50: initial kms support for off-chip TMDS/DP encoders

     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

:040000 040000 41f69d26a80082e19d3c76e6556ad5ef9eb2677d 
216d501e053e9d05136929593e90259c2e59dff0 M	drivers

But even though I marked that last bisection kernel good (since it 
didn't cause a black-out), it does have problems, namely that GTK themes 
are reset, and xrandr seems non-functional, inasmuch as my left-ward, 
secondary screen now seems to be treated as being situated to the right. 
No previous kernel in the bisection exercise caused anything of the like.

I'd be happy to try out any and all patches proposed, and as for the 
physical card, this is the relevant part:

02:00.0 VGA compatible controller: NVIDIA Corporation G92 [GeForce 9800 
GT] (rev a2)

Please let me know if there is anything else I can do to help resolve this!

Best regards,

Sune Mølgaard

-- 
What a gorgeous day. What effulgent sunshine. It was a day of this
sort the McGillicuddy brothers murdered their mother with an axe.
- W. C. Fields
