Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3FGPj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:39:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab3FGPjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:39:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: [PATCH v2] ethernet/arc/arc_emac - Add new driver
Date: Fri, 7 Jun 2013 17:39:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: netdev@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1370617656-18349-1-git-send-email-abrodkin@synopsys.com>
In-Reply-To: <1370617656-18349-1-git-send-email-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071739.44177.arnd@arndb.de>
X-Provags-ID: V02:K0:9TZwI4e7UuKds/WQx6GVxEJDSM12+YJZCjQ2Z52gJgW
 BWU+pMi03zPXr2yEmi84Re/6GBscM9j4YQ6TtUscr6BqObjekE
 TOVXdwjoI3SkKGUFpS0gg38dRQbTmpNO2SG3ZJIx9XcxL5w4OQ
 YvYRPJwcD3CzIQ0vev7NC82DHjDd1RXZ7k5Jc3HaYBOWsC4yYr
 Sb0CynKMgXcO4SVrI+pFix5yoNxMJXWFXd103cDiuEsmujgWPX
 TzHO1/A5l2VhLqJ7tBfn3z7Wu6MuNZMmS5Xok1Ux9RZtVAwxpF
 B1/WBLekTbP7u0kaBNNCh+QNANcdyyrfCRGPLnRD4EZEHKv1vd
 dK8gd/c8NFIuuhLGsTk4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013, Alexey Brodkin wrote:
> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
> ARCAngel4/ML50x.
> 
> This is based off of current Linus tree, build tested for x86.
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Reviewed-by: Vineet Gupta <vgupta@synopsys.com>
> Reviewed-by: Mischa Jonker <mjonker@synopsys.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
