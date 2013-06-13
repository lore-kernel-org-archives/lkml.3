Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3FMCb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:31:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:23441 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3FMCbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:31:23 -0400
X-Spam-Score: -100.8
Message-ID: <51B92EC9.3050003@asianux.com>
Date: Thu, 13 Jun 2013 10:30:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        "dhowells@redhat.com" <dhowells@redhat.com>, tony.luck@intel.com,
        fenghua.yu@intel.com, yasutake.koichi@jp.panasonic.com
CC: linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, linux-am33-list@redhat.com,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [Suggestion] arch/*/include/asm/bitops.h: about __set_bit() API.
References: <51B30285.6020503@asianux.com>
In-Reply-To: <51B30285.6020503@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 06:08 PM, Chen Gang wrote:
> Several architectures have different __set_bit() API to others, in
> standard API, 2nd param of __set_bit() is 'unsigned long *', but:
> 
>   in 'min10300', it is 'unsigned char *',

Oh, it is my fault, for 'mn10300' it is no issue, it is not 'unsigned
char *' (it is a generic one which can match any type).

Also 'min10300' --> 'mn10300'.



Thanks.
-- 
Chen Gang

Asianux Corporation
