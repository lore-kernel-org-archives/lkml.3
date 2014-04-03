Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbaDCAWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:22:13 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:44132 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161116AbaDCAWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:22:11 -0400
MIME-Version: 1.0
X-Originating-IP: [190.5.20.8]
In-Reply-To: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
	<1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
Date: Wed, 2 Apr 2014 21:15:41 -0300
Message-ID: <CAAEAJfAmRMbFhR7=3odLQpR0_hm1zoqhT70c9Ks5LHQCj8hbkA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] staging: vt6655: style fixes
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <ezequiel@vanguardiasur.com.ar>
To: =?ISO-8859-1?Q?Guido_Mart=EDnez?= <guido@vanguardiasur.com.ar>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, forest@alittletooquiet.net,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        driverdev-devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guido,

On 2 April 2014 14:53, Guido Martínez <guido@vanguardiasur.com.ar> wrote:
> Miscellaneous style fixes for the vt6655 driver. Should not affect
> functionality at all. Also remove dead code and some stale comments.
> Shrink driver size by 1100 lines.
>

Just a suggestion for future patches. It's good practice to add a
series changelog
to the cover letter, to summarize to changes from one patchset version
to the next one.

You can find lots of examples in the MLs. Here's one:

(See the "Changes from ..." section)
http://comments.gmane.org/gmane.linux.drivers.mtd/51937
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
