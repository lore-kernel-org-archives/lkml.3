Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3GWDcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 23:32:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33280 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3GWDcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 23:32:15 -0400
Message-ID: <51EDF93B.1070101@wwwdotorg.org>
Date: Mon, 22 Jul 2013 20:32:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] decompressors: fix "no limit" output buffer length
References: <1374476169-32194-1-git-send-email-acourbot@nvidia.com> <1374516481.14712.3.camel@linaro1.home> <51EDE724.5020507@nvidia.com>
In-Reply-To: <51EDE724.5020507@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 07:15 PM, Alex Courbot wrote:
...
> Although the patch seems ok to me in its current form, there are two
> points for which I still have small doubts:
> 
> 1) Whether size_t and pointers will have the same size on all platforms.

ptrsize_t?
