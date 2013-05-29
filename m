Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966086Ab3E2TFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:05:47 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62460 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965653Ab3E2TFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:05:42 -0400
Date: Wed, 29 May 2013 20:05:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: Re: [PATCH 2/3] ARM: u8540: Add Pinctrl Device Tree settings for
 uart0, uart2
Message-ID: <20130529190537.GJ3012@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
 <1369661455-17839-3-git-send-email-gabriel.fernandez.st@gmail.com>
 <20130528100941.GK22683@gmail.com>
 <CACRpkdYUBn4sv2vtTa1dNsd6RnCVRvep168pmiCzhF1fYsRvCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYUBn4sv2vtTa1dNsd6RnCVRvep168pmiCzhF1fYsRvCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would actually like to rename all the ux500-related files ste-*
> so they get grouped together in the filelist, but I've heard that there
> was a plan to create per-vendor subdirs in arch/arm/boot/dts
> so maybe I should go for that instead?

Yes, I too thought about doing this. I'll wait for the new folders though.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
