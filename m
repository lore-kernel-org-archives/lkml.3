Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3JDU7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:59:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60444 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3JDU7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:59:49 -0400
Message-ID: <524F2C43.9070302@wwwdotorg.org>
Date: Fri, 04 Oct 2013 14:59:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
CC: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: core: Always warn when using a dummy regulator
References: <1380883464-28851-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1380883464-28851-1-git-send-email-broonie@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 04:44 AM, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> This helps people spot if they have missed a supply from a device tree or
> equivalent data structure.
> 
> Suggested-by: Stephen Warren <swarren@nvidia.com>

Oh, well I was going to ack it, but I guess there's no point since I
suggested it:-)
