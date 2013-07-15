Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3GOPti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:49:38 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53474 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab3GOPth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:49:37 -0400
Message-ID: <51E41A0C.2050408@linaro.org>
Date: Mon, 15 Jul 2013 16:49:32 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: xen-devel@lists.xen.org, Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH] xen/control: protect functions with CONFIG_HIBERNATE_CALLBACKS
 to avoid warning
References: <1373898275-15765-1-git-send-email-julien.grall@linaro.org> <20130715152714.GD5774@phenom.dumpdata.com> <51E41975.3070706@citrix.com>
In-Reply-To: <51E41975.3070706@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot the different cc.

On 07/15/2013 04:47 PM, Julien Grall wrote:
> On 07/15/2013 04:27 PM, Konrad Rzeszutek Wilk wrote:
>> On Mon, Jul 15, 2013 at 03:24:35PM +0100, Julien Grall wrote:
>>> If CONFIG_HIBERNATE_CALLBACKS is not set gcc will issue warnings:
>>> drivers/xen/manage.c:46:13: warning: 'xen_hvm_post_suspend' defined but not used [-Wunused-function]
>>> drivers/xen/manage.c:52:13: warning: 'xen_pre_suspend' defined but not used [-Wunused-function]
>>> drivers/xen/manage.c:59:13: warning: 'xen_post_suspend' defined but not used [-Wunused-function]
>>
>> Have you checked the upstream kernel?
> 
> My apologies, I forgot to check upstream for this patch.
> 

