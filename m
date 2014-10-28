Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaJ1MGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:06:48 -0400
Received: from smtp-out-146.synserver.de ([212.40.185.146]:1128 "EHLO
	smtp-out-146.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaJ1MGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:06:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9246
Message-ID: <544F86C1.8040500@metafoo.de>
Date: Tue, 28 Oct 2014 13:06:25 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Qais Yousef <qais.yousef@imgtec.com>, linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 00/11] Add AXD Audio Processing IP driver
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 12:26 PM, Qais Yousef wrote:
> AXD Audio Processing IP performs audio decoding, encoding, mixing, equalisation,
> synchronisation and playback. This series adds the driver and DT binding
> document.
> [...]
> I added it to drivers/char as this is the best location I could think of at the
> moment. It doesn't fit in alsa subsystem but I Cced them to confirm.
 > [...]

I think it will fit in nicely.

- Lars

