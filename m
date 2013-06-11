Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3FKRWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:22:12 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57190 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3FKRWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:22:10 -0400
Date: Tue, 11 Jun 2013 12:22:05 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH V5 27/30] Documentation: thermal: Explain the exynos
 thermal driver model
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
	<1370955220-2949-28-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1370955220-2949-28-git-send-email-amit.daniel@samsung.com>
	(from amit.daniel@samsung.com on Tue Jun 11 07:53:37 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1370971325.2776.99@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 07:53:37 AM, Amit Daniel Kachhap wrote:
> This patch updates the documentation to explain the driver model
> and file layout.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  Documentation/thermal/exynos_thermal |   43  
> ++++++++++++++++++++++++++-------
>  1 files changed, 34 insertions(+), 9 deletions(-)
...
> -TMU(Thermal Management Unit) in EXYNOS4 generates interrupt
> +TMU(Thermal Management Unit) in EXYNOS4/5 generates interrupt
>  when temperature exceeds pre-defined levels.
> -The maximum number of configurable threshold is four.
> +The maximum number of configurable threshold is five.

Was that a driver change or was that a chipset change that only applies  
to version 5?

Rob