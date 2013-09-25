Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3IYXBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:01:15 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58541 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3IYXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:01:14 -0400
Message-ID: <52436B32.4040109@lwfinger.net>
Date: Wed, 25 Sep 2013 18:01:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] rtlwifi: Remove extern from function prototypes
References: <cover.1380137609.git.joe@perches.com> <a958df5dc3065ce517726dc54087639e13ffee8f.1380137610.git.joe@perches.com>
In-Reply-To: <a958df5dc3065ce517726dc54087639e13ffee8f.1380137610.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 02:37 PM, Joe Perches wrote:
> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
>
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

