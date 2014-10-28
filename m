Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaJ1Lzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:55:45 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:38213 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaJ1Lzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:55:44 -0400
Message-ID: <544F8439.4080402@ladisch.de>
Date: Tue, 28 Oct 2014 12:55:37 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Qais Yousef <qais.yousef@imgtec.com>, linux-kernel@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/11] Add AXD Audio Processing IP driver
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qais Yousef wrote:
> AXD Audio Processing IP performs audio decoding, encoding, mixing, equalisation,
> synchronisation and playback.

What exactly do you mean with "synchronisation" and "playback"?

> It doesn't fit in alsa subsystem but I Cced them to confirm.

... because those two words sound like something that a sound card could do.

> I added it to drivers/char as this is the best location I could think of at the
> moment.

drivers/misc?


Regards,
Clemens
