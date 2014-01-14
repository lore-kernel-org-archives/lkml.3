Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaANDq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:46:26 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:51342 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaANDqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:46:24 -0500
Message-ID: <52D4B30A.1020800@iki.fi>
Date: Tue, 14 Jan 2014 05:46:18 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: device@lanana.org
CC: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: video4linux device name request for Software Defined Radio
References: <52AF4257.9030000@iki.fi>
In-Reply-To: <52AF4257.9030000@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.187.60
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi device manager,

On 16.12.2013 20:11, Antti Palosaari wrote:
> Hello,
>
> We need new video4linux device name for Software Defined Radio devices.
> Device numbers are allocated dynamically. Desired device name was
> /dev/sdr, but as it seems to be already reserved, it was made decision
> to apply /dev/swradio instead.
>
>
> 81 char    video4linux
> /dev/swradio0    Software Defined Radio device

  81 char	video4linux
		  0 = /dev/swradio0	Software Defined Radio device
		  1 = /dev/swradio1	Software Defined Radio device
		    ...


Resending device name request. Should I expect it is OK to add that 
device name even without a ack from manager?


regards
Antti

-- 
http://palosaari.fi/
