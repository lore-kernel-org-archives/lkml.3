Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbaDWUPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:15:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaDWUPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:15:00 -0400
Date: Wed, 23 Apr 2014 13:14:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH RESEND 1/2] rtc: 88pm860x: Use of_get_child_by_name
Message-Id: <20140423131459.fdd98d4e699524e17eca2c36@linux-foundation.org>
In-Reply-To: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
References: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 14:29:27 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> Use of_get_child_by_name to obtain reference to charger node instead of
> of_find_node_by_name which can walk outside of the parent node.

When fixing bugs please always include a description of the end-user
visible effects of that bug so that others can work out which kernel
versions need the fix.

Thanks.

