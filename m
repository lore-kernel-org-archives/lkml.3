Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaCCFVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:21:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59705 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaCCFVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:21:06 -0500
Message-ID: <5314113E.1030106@wwwdotorg.org>
Date: Sun, 02 Mar 2014 22:21:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markus Mayer <markus.mayer@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc
 tree
References: <20140303120241.11066f951d53c50fb14faf47@canb.auug.org.au>
In-Reply-To: <20140303120241.11066f951d53c50fb14faf47@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 06:02 PM, Stephen Rothwell wrote:
> Hi Stephen,
> 
> Today's linux-next merge of the bcm2835 tree got a conflict in 
> arch/arm/mach-bcm2835/Kconfig between commits ddb902cc3459 ("ARM: 
> centralize common multi-platform kconfig options") and
> 0676b21fffd1 ("ARM: bcm2835: enable V6K instead of plain V6") from
> the arm-soc tree and commit d30fe6272183 ("ARM: bcm2835: Move to
> mach-bcm directory") from the bcm2835 tree.

Olof, Arnd, Kevin,

Do you want me to rebase the patch that moves
arch/arm/mach-bcm2835/Kconfig into arch/arm/mach-bcm/Kconfig, or even
drop it and take it through arm-soc directly? Or, will you just handle
this when you merge the pull request?
