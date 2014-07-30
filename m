Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaG3JBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:01:32 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58846 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaG3JBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:01:30 -0400
Message-ID: <53D8B463.5060405@collabora.co.uk>
Date: Wed, 30 Jul 2014 11:01:23 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/5] regulator: core: Get voltage from parent if not available
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk> <1406651339-28901-2-git-send-email-javier.martinez@collabora.co.uk> <20140729182601.GA17528@sirena.org.uk>
In-Reply-To: <20140729182601.GA17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 08:26 PM, Mark Brown wrote:
> On Tue, Jul 29, 2014 at 06:28:55PM +0200, Javier Martinez Canillas wrote:
>> Load switches are modeled as regulators but they just provide
>> the voltage of their parent input supply. So the drivers for
> 
> Applied, thanks.  The term "load switch" is a bit unusual - they're
> usually just called switches (or sometimes FETs since that tends to be
> the implementation).
> 

Thanks, I used the terminology from the tps65090 data manual [0] that refers
these components as "load switches" all around the document. Although they are
called FETs indeed in the tables and register names.

Best regards,
Javier

[0]: http://www.ti.com/lit/gpn/tps65090
