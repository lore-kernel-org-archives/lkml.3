Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbbAKMgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:36:51 -0500
Received: from smtp-2.concepts.nl ([213.197.30.125]:33422 "EHLO
	smtp-2.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbAKMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:36:48 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2015 07:36:48 EST
Message-ID: <54B26ACE.90406@xmsnet.nl>
Date: Sun, 11 Jan 2015 13:21:34 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
Subject: 3.19-rc1 regression bisected No sound on Dell Latitude d430
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Concepts-MailScanner-Information: Please contact abuse@concepts.nl for more information
X-Concepts-MailScanner-ID: 1YAHWR-0001ij-67
X-Concepts-MailScanner: Found to be clean
X-Concepts-MailScanner-SpamCheck: 
X-Concepts-MailScanner-From: jmdebruin@xmsnet.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:

commit 3abb4f4d0e7aaad0d12004b5057f4486a688752b
Author: David Henningsson <david.henningsson@canonical.com>
Date:   Thu Oct 16 15:33:46 2014 +0200

     ALSA: hda - Use "Line Out" name instead of "PCM" when there are 
other outputs

     In case there are speakers or headphones as well, anything that only
     covers the line out should not be labelled "PCM". Let's name it
     "Line Out" instead for clarity.

     Signed-off-by: David Henningsson <david.henningsson@canonical.com>
     Signed-off-by: Takashi Iwai <tiwai@suse.de>

breaks the sound on my dell laptop.


-- 
Hans
