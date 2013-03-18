Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3CRPTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:19:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47764 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3CRPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:19:32 -0400
Message-ID: <51473081.2040607@wwwdotorg.org>
Date: Mon, 18 Mar 2013 09:19:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc
 tree
References: <20130318150415.7a9db62e8cfe03623a411ae9@canb.auug.org.au>
In-Reply-To: <20130318150415.7a9db62e8cfe03623a411ae9@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 10:04 PM, Stephen Rothwell wrote:
> Hi Stephen,
> 
> Today's linux-next merge of the bcm2835 tree got a conflict in 
> arch/arm/Kconfig between commit 15bc1fe67f66 ("ARM: cns3xxx:
> enable multiplatform support") from the arm-soc tree and commit
> f1ac922dec7e ("ARM: bcm2835: convert to multi-platform") from the
> bcm2835 tree.

Thanks. The resolution for the two bcm2835/arm-soc conflicts looks
fine. These conflicts should go away once I send bcm2835 pull requests
to arm-soc for inclusion in 3.10.
