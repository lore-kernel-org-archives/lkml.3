Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaLWRIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:08:48 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50613 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaLWRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <1419353032-10340-1-git-send-email-abrestic@chromium.org>
References: <1419353032-10340-1-git-send-email-abrestic@chromium.org>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 23 Dec 2014 09:08:25 -0800
Message-ID: <CAJiQ=7AB46Dz5hPKRjZXkmcanf4KTfcry87Ai503xX6yQOE_VQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] MIPS: Move device-trees into vendor sub-directories
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 8:43 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> Move the MIPS device-trees into the appropriate vendor sub-directories.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
> Changes from v1:
>  - renamed bcm -> brcm

Thanks, this works for me.  For both patches in the series:

Tested-by: Kevin Cernekee <cernekee@gmail.com>
