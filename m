Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3IRGNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:13:35 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:40889 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3IRGNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:31 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 23/28] of: introduce common FDT machine related functions
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1379372965-22359-24-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-24-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 22:44:25 -0500
Message-Id: <20130918034425.357F4C42CF1@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:09:19 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Introduce common of_flat_dt_match_machine and
> of_flat_dt_get_machine_name functions to unify architectures' handling
> of machine level model and compatible properties.
> 
> Several architectures match the root compatible string with an arch
> specific list of machine descriptors duplicating the same search
> algorithm. Create a common implementation with a simple architecture
> specific hook to iterate over each machine's match table.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>

Nice!

Acked-by: Grant Likely <grant.likely@linaro.org>

Thanks for doing this whole series. It's some really good improvements.

g.
