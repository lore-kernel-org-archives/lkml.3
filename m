Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaCLOyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:54:08 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62232 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaCLOyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <1394631305-4083-1-git-send-email-srinivas.kandagatla@st.com>
References: <1394631305-4083-1-git-send-email-srinivas.kandagatla@st.com>
Date: Wed, 12 Mar 2014 15:54:05 +0100
Message-ID: <CACRpkdZhHwp0_1XQV=6pmYrtU70yMNe1QfwQrekvM=UY4_AtRw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: Fix error check for of_irq_to_resource usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: kernel@stlinux.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srinivas.kandagatla@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 2:35 PM,  <srinivas.kandagatla@st.com> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch fixes an error check while using of_irq_to_resource.
> of_irq_to_resource returns non-zero interrupt number on success and zero
> on error. The driver was using error check is wrong way.
>
> Without this patch the driver will configure interrupt zero if there is
> no interrupt specified in the node.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Patch applied.

Yours,
Linus Walleij
