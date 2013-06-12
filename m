Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3FLMoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:44:01 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54061 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3FLMoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <1370864113-17895-16-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-16-git-send-email-tushar.behera@linaro.org>
Date: Wed, 12 Jun 2013 15:43:59 +0300
Message-ID: <CAHp75Ve31DA5WVWH7Ha0s+Voe8v77Q_8nOXhg1fKODb0zJxg5w@mail.gmail.com>
Subject: Re: [PATCH 15/15] lib: devres: Remove deprecated devm_request_and_ioremap
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        thierry.reding@gmail.com, patches@linaro.org,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 2:35 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> Now that all the users of devm_request_and_ioremap have been converted
> to use devm_ioremap_resource, remove the definition.

This is a function which was exported to the drivers including
third-party drivers.
I suggest to mark it as __deprecated and wait couple of release cycles.



--
With Best Regards,
Andy Shevchenko
