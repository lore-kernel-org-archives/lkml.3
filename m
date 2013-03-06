Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3CFWge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:36:34 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61076 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3CFWgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:36:33 -0500
MIME-Version: 1.0
In-Reply-To: <1362606521-16848-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362606521-16848-1-git-send-email-silviupopescu1990@gmail.com>
Date: Wed, 6 Mar 2013 23:36:32 +0100
Message-ID: <CAJK669ZrEEWX293W+C88xEw4e133yuwz+VJ5cbrsEKXECDQ-8Q@mail.gmail.com>
Subject: Re: [PATCH] CAIF: fix indentation for function arguments
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        Erwan YVIN <Erwan.Yvin@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 10:48 PM, Silviu-Mihai Popescu
<silviupopescu1990@gmail.com> wrote:
> This lines up function arguments on second and subsequent lines at the
> first column after the openning parenthesis of the first line.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

There is quite a bit of churn for stuff not even noticed by checkpatch --strict,
but it does improve the style...

Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
