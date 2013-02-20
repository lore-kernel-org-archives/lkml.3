Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab3BTTdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:33:21 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64280 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158Ab3BTTdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:33:20 -0500
MIME-Version: 1.0
In-Reply-To: <CANeU7Q=KHB=rZrTpJ+Nj+C-tAL3vMafSQsjrCHGvGEydcULGSQ@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7Q=KHB=rZrTpJ+Nj+C-tAL3vMafSQsjrCHGvGEydcULGSQ@mail.gmail.com>
Date: Wed, 20 Feb 2013 11:33:19 -0800
X-Google-Sender-Auth: 3fHfiM7fCEwbcWvRWjH1c5eei0I
Message-ID: <CANeU7QmVNkmf29qA52W+j0MTUJGA=pL7e+oXJy-s9Qf0tn3miQ@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:29 AM, Chris Li <lkml@chrisli.org> wrote:
>
> Here it is the dmesg from the FC18 live CD kernel. No black screen.

Sorry please ignore my previous dmesg. It was boot with i915.modeset=0.
I am doing another one without that line.

Chris
