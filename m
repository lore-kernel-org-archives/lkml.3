Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3KBBAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 21:00:31 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:60396 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3KBBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 21:00:28 -0400
MIME-Version: 1.0
In-Reply-To: <1383343739-23080-2-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
	<1383343739-23080-2-git-send-email-sboyd@codeaurora.org>
Date: Fri, 1 Nov 2013 20:00:27 -0500
Message-ID: <CAL_Jsq+_Z8s1on3zbwUSV8y3hq9FE4hejLEzMAfNy1nz8KfsQg@mail.gmail.com>
Subject: Re: [PATCH 01/11] devicetree: bindings: Document cpu enable-method
 for ARM CPUs
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 5:08 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> From: Rohit Vaswani <rvaswani@codeaurora.org>
>
> According to the ePAPR CPUs should have an enable method. On ARM
> the enable-method property has not been used so far, so document
> this property as an optional property and add the spin-table
> method as one value
>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> [sboyd: Split off into separate patch]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Rob Herring <rob.herring@calxeda.com>
