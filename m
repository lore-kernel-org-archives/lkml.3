Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3CSDd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:33:28 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49935 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3CSDd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <000101ce2445$f61b7120$e2525360$%han@samsung.com>
References: <000001ce2445$e1927be0$a4b773a0$%han@samsung.com>
	<000101ce2445$f61b7120$e2525360$%han@samsung.com>
Date: Tue, 19 Mar 2013 09:03:26 +0530
Message-ID: <CAK9yfHxMf8+Kb6qup70M+iOGznH6AVgKMRf8+xXa757oxQZdQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] extcon: max8997: add missing const
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2013 07:33, Jingoo Han <jg1.han@samsung.com> wrote:
> Fixed the checkpatch warning as below:
>
>   WARNING: static const char * array should probably be static const char * const
>   #163: FILE: drivers/extcon/extcon-max8997.c:163:
>   +static const char *max8997_extcon_cable[] = {
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 20772ad..6e8724f 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -160,7 +160,7 @@ enum {
>         _EXTCON_CABLE_NUM,
>  };
>
> -static const char *max8997_extcon_cable[] = {
> +static const char const *max8997_extcon_cable[] = {

Shouldn't this be "static const char * const max8997_extcon_cable[]"
as suggested by checkpatch (as mentioned in your commit log)?


-- 
With warm regards,
Sachin
