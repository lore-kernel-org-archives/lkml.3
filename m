Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaBFJda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:33:30 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35077 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaBFJd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:33:26 -0500
MIME-Version: 1.0
In-Reply-To: <52F25209.2010506@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-60-git-send-email-paul.gortmaker@windriver.com>
	<CACRpkdYk6cOO-JZbe887ihJaWE5JMjuXm3EVcZmE1jCeL2BODQ@mail.gmail.com>
	<20140124095827.1ee8ddcfed8d1c8e0a6d3dbd@canb.auug.org.au>
	<20140124022154.GA13428@windriver.com>
	<CACRpkdYF2f1Ekp6JYwntj+UhbceWtMN==yKC7emsXHfktcZZsg@mail.gmail.com>
	<52F25209.2010506@windriver.com>
Date: Thu, 6 Feb 2014 10:33:25 +0100
Message-ID: <CACRpkdZbam+UcKhBXwwLE+cDDoUgCPUQZ-afOD+qyJt9aJfw4g@mail.gmail.com>
Subject: Re: [PATCH 59/73] drivers/gpio: delete non-required instances of
 include <linux/init.h>
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 4:00 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On 14-02-05 08:02 AM, Linus Walleij wrote:

>> So I can add these patches to my devel branches now I think?
>
> The patches that weren't taken by maintainers before 3.14-rc1 were
> encompassed in the cleanup pull request to Linus sent yesterday.

Sweet! Thanks Paul.

Yours,
Linus Walleij
