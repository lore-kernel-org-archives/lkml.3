Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaCHU7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 15:59:54 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55655 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaCHU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 15:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <1394235527-8999-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394235527-8999-1-git-send-email-florian.vaussard@epfl.ch>
Date: Sat, 8 Mar 2014 14:59:51 -0600
X-Google-Sender-Auth: M9Cc67tQfHzdQpnx7OAOKj1Yf4k
Message-ID: <CAL_JsqLp_v_BVSMa6DZ8oiV2HkTBeASYk+aa=heAcwE4CQcY7Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] checkpatch: enhance compatible string checking
From: Rob Herring <robh@kernel.org>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 5:38 PM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> Hi,
>
> This series proposes a number of fixes and enhancements to the checks
> performed on compatible strings:
>
> 1) Fix vendor check for strings with dashes
> 2) Fix spurious vendor warning, when there is no vendor
> 3) Check for compatible strings in .c and .h files too
> 4) Match only at the begining of each line in vendor-prefixes.txt

For the series:

Acked-by: Rob Herring <robh@kernel.org>

I haven't had a chance to test, but will try to do so this week.

Rob
