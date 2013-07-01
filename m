Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3GAOGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:06:32 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46355 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3GAOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:06:31 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.177.224]
In-Reply-To: <1370034984-29636-1-git-send-email-s-anna@ti.com>
References: <1370034984-29636-1-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 1 Jul 2013 17:06:09 +0300
Message-ID: <CAK=Wgbb=PbeWZi08S-veP-ssxzZ86t0=EivCmFS1FDZRzHzHVw@mail.gmail.com>
Subject: Re: [PATCH 3/3] remoteproc: free carveout memories only after
 unmapping them
To: Suman Anna <s-anna@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 12:16 AM, Suman Anna <s-anna@ti.com> wrote:
> It is not preferable to have the allocated pages for carveout
> memories freed before they are unmapped. The code that deals
> with the cleanup of carveout memories is therefore moved after
> the corresponding mapping entries were cleaned up.
>
> This is mostly a no-op since the remote processors are already
> stopped when the cleanup function is called, but this will make
> the cleanup code follow the exact reverse path of allocation.
>
> Signed-off-by: Suman Anna <s-anna@ti.com>

Applied, thanks.
