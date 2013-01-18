Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3ARPGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:06:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3ARPF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:05:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 70/76] ARC: [Review] Multi-platform image #3: switch to board callback
Date: Fri, 18 Jan 2013 15:05:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-71-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-71-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181505.53506.arnd@arndb.de>
X-Provags-ID: V02:K0:KyMwPplBLYNv019iiqcE0GhgLRFgdnb80KkQRLJn9oJ
 pYkElcDWhrAnrfanqZIFi7RGTc0X6MggreMu4IuBnEim+6Ox75
 TNSSn6qz70GEVaMaGNHXPTOmfre3FZBna4ZcYK4kWo+w2uibct
 xyclJsb0789h0BwYkqn007B4VWSYL/Rze5maHmpEz7R7CshCQ6
 L3tQsbnKkXdEqmlAirmrkOjyFXRtvQoWN21tEupas5YOllKwae
 05//NDMf1uKLbDdjNMFLO+pd3NjhLp2dRUACgBI4b11rcmZ9HK
 dKMK3uzoPwfuKiaL/v9dFeEst7+KLGXLxYqO75Z3FaFYXs8ayr
 0A67xbiON8N393J8UKJI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> -platform API is retired and instead callbacks are used
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
