Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3FDMOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:14:53 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55456 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3FDMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:14:39 -0400
Date: Tue, 4 Jun 2013 13:14:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, sameo@linux.intel.com, wim@iguana.be,
        lgirdwood@gmail.com, gg@slimlogic.co.uk, t-kristo@ti.com,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v2] mfd: DT bindings for the palmas family MFD
Message-ID: <20130604121434.GN3370@gmail.com>
References: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jun 2013, J Keerthy wrote:

> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> Add the various binding files for the palmas family of chips. There is a
> top level MFD binding then a seperate binding for regulators IP blocks on chips.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---
> Changes from v1:
> * Corrected ti,ldo6_vibrator property ---> ti,ldo6-vibrator
> * Added the irq.h header file inclusion for defining type of interrupt
> 
>  Documentation/devicetree/bindings/mfd/palmas.txt   |   49 +++++++++++++++
>  .../devicetree/bindings/regulator/palmas-pmic.txt  |   65 ++++++++++++++++++++
>  2 files changed, 114 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
>  create mode 100644 Documentation/devicetree/bindings/regulator/palmas-pmic.txt

Is there a driver to go with this patch, or was the documentation an
afterthought in this case? If the latter is true I'd be happy to apply
this patch with an Ack from Stephen or one of the other previous
reviewers.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
