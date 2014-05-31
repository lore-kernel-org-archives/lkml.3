Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaEaVRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 17:17:12 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49737 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaEaVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 17:17:10 -0400
Message-ID: <538A46DF.1040009@cogentembedded.com>
Date: Sun, 01 Jun 2014 01:17:19 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
CC: kernel-janitors@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] USB: kl5kusb105: Remove useless return variables
References: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/31/2014 05:14 PM, Peter Senna Tschudin wrote:

> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.

   The patch does more than just that, it also removes commented out code.

> Verified by compilation only.

[...]

> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

WBR, Sergei


