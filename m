Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3GIVRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:17:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58053 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab3GIVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:17:11 -0400
Message-ID: <51DC7DD4.7080001@wwwdotorg.org>
Date: Tue, 09 Jul 2013 15:17:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 01/14] fbdev: simplefb: add init through platform_data
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com> <1372940714-12470-2-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372940714-12470-2-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 06:25 AM, David Herrmann wrote:
> If we create proper platform-devices in x86 boot-code, we can use simplefb
> for VBE or EFI framebuffers, too. However, there is normally no OF support
> so we introduce a platform_data object so x86 boot-code can pass the
> parameters via plain old platform-data.
> 
> This also removes the OF dependency as it is not needed. The headers
> provide proper dummies for the case OF is disabled.
> 
> Furthermore, we move the FORMAT-definitions to the common platform header
> so initialization code can use it to transform "struct screen_info" to
> the right format-name.

Patches 1 and 5,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
