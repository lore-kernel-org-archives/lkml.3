Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab3FQKe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:34:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61103 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3FQKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:34:57 -0400
Message-ID: <51BEE64C.80608@linaro.org>
Date: Mon, 17 Jun 2013 16:04:52 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 11/15] regulator: ti-abb: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-12-git-send-email-tushar.behera@linaro.org> <51BED2F9.1020307@linaro.org> <20130617100525.GA1403@sirena.org.uk>
In-Reply-To: <20130617100525.GA1403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 03:35 PM, Mark Brown wrote:
> On Mon, Jun 17, 2013 at 02:42:25PM +0530, Tushar Behera wrote:
>> On 06/10/2013 05:05 PM, Tushar Behera wrote:
>>> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
>>> introduced devm_ioremap_resource() and deprecated the use of
>>> devm_request_and_ioremap().
> 
>> Ping.
> 
> Don't send contentless pings.  I seem to recall you already got some
> review on this.
> 

The comment was on removal of the error message during
devm_ioremap_resource() error check . Since there are a few other error
messages in the driver (related to devm_ioremap_nocache) in the same
format, I prefer to leave this error message right now.

There were no other comments.

-- 
Tushar Behera
