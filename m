Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbaKSQJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:09:42 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44807 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbaKSQFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <1416412231-2752-1-git-send-email-lee.jones@linaro.org>
References: <1416412231-2752-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 19 Nov 2014 14:04:58 -0200
Message-ID: <CAOMZO5CwFSRUoVb2j=X=fzaqVN1gUyRki70ewrGrwqLWSHMoAg@mail.gmail.com>
Subject: Re: [PATCH] thermal: sti: Ignore suspend/resume functions when !PM
From: Fabio Estevam <festevam@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, edubezval@gmail.com,
        kernel@stlinux.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 1:50 PM, Lee Jones <lee.jones@linaro.org> wrote:
> Prevents build warning:
>
> st_thermal.c:278:12:
>     warning: ‘st_thermal_suspend’ defined but not used [-Wunused-function]
> st_thermal.c:286:12:
>     warning: ‘st_thermal_resume’ defined but not used [-Wunused-function]
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>
> v1 => v2:
>  - CONFIG_PM => CONFIG_PM_SLEEP suggested by David Paris.

You should also update the Subject to 'when !PM_SLEEP'
