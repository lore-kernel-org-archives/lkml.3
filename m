Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBMV2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:28:02 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57456 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBMV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:28:00 -0500
X-Auth-Info: 8rkOTgE+tS6blttqMUrZIDnu8U7jPceMWKGWAyXzcf8=
Date: Thu, 13 Feb 2014 22:27:57 +0100
From: Gerhard Sittig <gsi@denx.de>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: core: Validate lenght of the transfers in message
Message-ID: <20140213212757.GM4524@book.gsilab.sittig.org>
References: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 16:46 +0200, Ivan T. Ivanov wrote:
> 
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> SPI transfer lenght should be a power-of-two multiple
> of eight bits.

Are you suggesting that an SPI transfer cannot consist of e.g.
three bytes?  This would be surprising, and certainly would be
rather wrong an assumption.  Am I missing/misunderstanding
something?


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
