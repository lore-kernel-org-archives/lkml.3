Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3KYFbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 00:31:16 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:59203 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3KYFbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 00:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <1383586280-4765-1-git-send-email-james.d.ralston@intel.com>
References: <1383586280-4765-1-git-send-email-james.d.ralston@intel.com>
Date: Mon, 25 Nov 2013 09:31:14 +0400
Message-ID: <CAA1sL1Q=KV08FRYYvrzy+c3PX4-3Lx90o0SXbXsngAhooi0TKQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH
From: Alexander Beregalov <a.beregalov@gmail.com>
To: James Ralston <james.d.ralston@intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seth Heasley <seth.heasley@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2013 21:31, James Ralston <james.d.ralston@intel.com> wrote:
> This patch adds the TCO Watchdog Device IDs for the Intel Wildcat Point-LP PCH.
>
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
>  drivers/mfd/lpc_ich.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>

> +       [LPC_WPT_LP] = {
> +               .name = "Lynx Point_LP",
> +               .iTCO_version = 2,
> +       },

Hi
Shouldn't it be "Wildcat Point_LP"?
