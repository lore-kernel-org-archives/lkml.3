Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbbAHO1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:27:47 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:27229 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbAHO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:27:46 -0500
Message-ID: <54AE9361.80004@imgtec.com>
Date: Thu, 8 Jan 2015 11:25:37 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>,
        Naidu Tellapati <Naidu.Tellapati@imgtec.com>,
        Arul Ramasamy <Arul.Ramasamy@imgtec.com>
Subject: Re: [PATCH v7 3/4] pdm: Imagination Technologies PDM DAC driver
References: <1420651215-3836-1-git-send-email-ezequiel.garcia@imgtec.com>	<1420651215-3836-4-git-send-email-ezequiel.garcia@imgtec.com> <20150108142136.757eaeef@lxorguk.ukuu.org.uk>
In-Reply-To: <20150108142136.757eaeef@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.100.200.148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/08/2015 11:21 AM, One Thousand Gnomes wrote:
[..]
> 
> and - you get the idea 8)
> 

Thanks for all the comments. Before preparing a new patchset fixing
them, I'd like to check with the maintainers (Thierry on PWM, and Greg
on misc) about the validity of the general approach.

Thierry had concerns about the syscon usage, and I'd like to make sure
we settle that.

Guys, any feedback?

Thanks a lot!
-- 
Ezequiel
