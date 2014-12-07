Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaLGXpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 18:45:06 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36704 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLGXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 18:45:03 -0500
MIME-Version: 1.0
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 8 Dec 2014 10:44:40 +1100
Message-ID: <CAGRGNgWDJqV=XD+6q26Ma=m1sEi1kvLWsjq6=RjRVSFTxow0Qg@mail.gmail.com>
Subject: Re: [PATCH 0/20] fix misspelling of current function in string
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk,
        Joe Perches <joe@perches.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-mtd@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Mon, Dec 8, 2014 at 6:20 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> These patches replace what appears to be a reference to the name of the
> current function but is misspelled in some way by either the name of the
> function itself, or by %s and then __func__ in an argument list.

Would there be any value in doing this for _all_ cases where the
function name is written in a format string?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
