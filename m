Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaDRUtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:49:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43151 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbaDRUtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:49:07 -0400
Message-ID: <53518FAC.8020504@zytor.com>
Date: Fri, 18 Apr 2014 13:48:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
CC: lftan.linux@gmail.com, cltang@codesourcery.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 05:26 AM, Ley Foon Tan wrote:
> This patchset adds the Linux kernel port for Nios II processor from Altera.
> The nios2 Linux port follows the guidance for new architecture ports using
> generic headers (including unistd.h).

Did the generic headers ever get updated to match Linus' guidance that
any new architecture ports should use a 64-bit time_t?

	-hpa


