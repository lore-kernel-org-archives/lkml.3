Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3AJTbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:31:15 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:41693 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3AJTbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:31:13 -0500
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D392@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A05C@USINDEM103.corp.hds.com>
	<CA+8MBbKTHQJoeRVUGZr+rcXm+VwOw2vSG31Cwnrg-sc=CzLu9w@mail.gmail.com>
	<A5ED84D3BB3A384992CBB9C77DEDA4D414A3D392@USINDEM103.corp.hds.com>
Date: Thu, 10 Jan 2013 11:31:12 -0800
Message-ID: <CA+8MBbLYrmY12rRaG+gTcji3EMLYT0SzEUxXHj6uGoa0ydReNg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] pstore: Avoid deadlock in panic and
 emergency-restart path
From: Tony Luck <tony.luck@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 10:23 AM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> Please apply these to your tree.

Ok. Applied and pushed to my "next" branch. Should show up in linux-next
in the next day or two.

-Tony
