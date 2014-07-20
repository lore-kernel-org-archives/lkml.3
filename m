Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaGTV3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:29:09 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:54017 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaGTV3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9xbM4fvo8uKrhJU8Mvp_3HQ=PcrBgq4p_JL0cy_-rX2nL_Bg@mail.gmail.com>
References: <1405661102-11967-1-git-send-email-xerofoify@gmail.com>
	<CAA9xbM4fvo8uKrhJU8Mvp_3HQ=PcrBgq4p_JL0cy_-rX2nL_Bg@mail.gmail.com>
Date: Sun, 20 Jul 2014 17:29:04 -0400
Message-ID: <CAPDOMVh59+sRfDOLw5VEHXdbaet5B2xv=REJUSUJ+um6jMoe0Q@mail.gmail.com>
Subject: Re: [PATCH] ia64: Fix me add register r8
From: Nick Krause <xerofoify@gmail.com>
To: =?UTF-8?Q?=C3=89meric_MASCHINO?= <emeric.maschino@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 4:49 PM, Émeric MASCHINO
<emeric.maschino@gmail.com> wrote:
> Hi,
>
> Well, I'm wondering why the original author of this FIXME comment
> didn't fix the issue him/herself. Can you track down who added this
> comment? I fear that this simple comment was actually here to point to
> something more subtle...
>
>      Émeric
>


 Émeric,
I ran git blame on the file and I got this name,  Shaohua Li
for the fix me and the whole function .

Nick
