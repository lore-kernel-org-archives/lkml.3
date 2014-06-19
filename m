Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaFSNck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:32:40 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:51593 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbaFSNci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:32:38 -0400
Date: Thu, 19 Jun 2014 15:32:35 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Lee Jones <lee.jones@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC
 regulators
Message-ID: <20140619153235.09b2de40@linux.lan.towertech.it>
In-Reply-To: <20140618141048.GA15956@lee--X1>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
	<1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk>
	<20140617211747.GY29841@lee--X1>
	<53A16047.7010409@collabora.co.uk>
	<20140618141048.GA15956@lee--X1>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 15:10:48 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> > So I guess you should either a) take the whole patch-set through your mfd tree
> > or b) merge the mfd patches and create an immutable branch that can be pulled by
> > Mark, Mike and Alessandro.
> > 
> > I don't know what's the preferred workflow in these cases...  
> 
> That's fine.  I'm happy to create shared branches when required.

 mfd tree will be ok.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

