Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaCYMvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:51:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47145 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbaCYMvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:51:14 -0400
Date: Tue, 25 Mar 2014 09:50:50 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org
Subject: Re: [RFC 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Message-ID: <20140325125050.GB665@arch.cereza>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mar 25, Lee Jones wrote:
> 
> This patch-set was written against kernel version v3.4, but applies
> cleanly to v3.13-rc7 which it is currently based. I understand that
> the core has changed significantly since and that some of the
> infrastructure this driver provides is now available either through
> the framework or similar means. I'm looking for someone with inside
> knowledge to draw attention to those areas so we can align with the
> most recent API.
> 

Please push a git branch. It will be nice to have a way of seeing the 'big
picture' without applying the 47 patches.

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
