Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaCCAAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:00:49 -0500
Received: from mout.gmx.net ([212.227.15.18]:62889 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbaCCAAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:00:46 -0500
Message-ID: <5313C616.9010104@gmx.de>
Date: Mon, 03 Mar 2014 01:00:22 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        jdl@jdl.com, devicetree-compiler@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Consistently use xrealloc instead of realloc
References: <1393792741-29043-1-git-send-email-xypron.glpk@gmx.de> <20140302234140.GD12916@voom.fritz.box>
In-Reply-To: <20140302234140.GD12916@voom.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:vpRAq8TrOXWPE6qPJjFVWjxtNlzKagkp0JoOctlJbHJduKvJr/v
 v5PvDWwpReIBNkTfqE/arqil4Rulerj2Q9sfIh2XvlYvS87KIKOFSEm6QHZx8ReiywDNUjj
 fSLFuxQId8huQX3L+boAZBkzpylETbKGaJKKYbaMG6scH4emfrwzb3nW9zuirs7QL6GMjsS
 Pso9ZoqzNlygMvwSdw0qA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that in general dtc patches should be CCed to myself and Jon
> Loeliger <jdl@jdl.com>, the dtc maintainers.
>

This is the relevant section in file MAINTAINERS of Torvald's git.
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS

OPEN FIRMWARE AND FLATTENED DEVICE TREE
M:  Grant Likely <grant.likely@linaro.org>
M:  Rob Herring <robh+dt@kernel.org>
L:  devicetree@vger.kernel.org
W:  http://fdt.secretlab.ca
T:  git git://git.secretlab.ca/git/linux-2.6.git
S:  Maintained
F:  drivers/of/
F:  include/linux/of*.h
F:  scripts/dtc/
K:  of_get_property
K:  of_match_table

If the information is not accurate, please, have it updated.

Best regards

Heinrich Schuchardt
