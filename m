Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3FXPXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:23:05 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:20864 "HELO
	mail-ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751778Ab3FXPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:23:02 -0400
X-Greylist: delayed 750 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 11:23:01 EDT
Message-ID: <51C8615D.7020603@keymile.com>
Date: Mon, 24 Jun 2013 17:10:21 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
CC: "Brunck, Holger" <Holger.Brunck@keymile.com>
Subject: The UAPI header file split
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2013 15:10:21.0910 (UTC) FILETIME=[F23E8760:01CE70EC]
X-ESAFE-STATUS: [srvchber1306.keymile.net] Mail allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Michael,

I'm in the unpleasant position of needing to apply the UAPI 
disintegration to some "proprietary" stuff, and I would like the use the 
same scripts used mainline.
Would it be possible get ahold of the necessary scripts?

I tried looking and I only found [1] where the reference provided [2] is 
now broken. I found a patch [3] which should contain those scripts but I 
am afraid it might be outdated.

Any pointers?

Thank you,
Gerlando

[1] http://lwn.net/Articles/507794/
[2] http://people.redhat.com/~dhowells/uapi.tar.xz
[3] http://marc.info/?l=linux-kernel&m=131186860909620&w=2
