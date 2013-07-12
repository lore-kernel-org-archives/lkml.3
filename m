Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3GLWGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:06:45 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:47975 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3GLWGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:06:43 -0400
Message-ID: <51E07DEF.6030308@gmail.com>
Date: Fri, 12 Jul 2013 17:06:39 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gps6507x.txt: Remove executable bits
References: <1373650307.2614.10.camel@joe-AO722>
In-Reply-To: <1373650307.2614.10.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:31 PM, Joe Perches wrote:
> Documentation shouldn't be executable.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
> diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
> old mode 100755
> new mode 100644
> 
> 

