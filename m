Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCLWhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:37:01 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33003 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaCLWg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:36:59 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:cc3c:af8a:7223:1c24]
In-Reply-To: <20140312220350.3c35bce7dff139a73a9c8262@kernel.org>
References: <20140312220350.3c35bce7dff139a73a9c8262@kernel.org>
Date: Wed, 12 Mar 2014 15:36:58 -0700
Message-ID: <CAOesGMiK-8_0vt7jWSMT3oaoPUz5fS92ztknC-HhsEYt2XCNZQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 3:03 PM, Mark Brown <broonie@kernel.org> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in include/asm-generic/vmlinux.lds.h between commit 6c3ff8b11a16ec69 ("ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp") from the  tree and commit f618c4703a14672d27 ("drivers: of: add support for custom reserved memory drivers") from the devicetree tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

LGTM from the arm-soc side.


-Olof
