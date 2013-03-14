Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab3CNAC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:02:28 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:43944 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab3CNAC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <5140FF55.7040708@gmail.com>
References: <5140FF55.7040708@gmail.com>
Date: Thu, 14 Mar 2013 04:02:26 +0400
Message-ID: <CAL0eWdEfS2vVPNYza1oiL-nzg3c2C4nn0TYWTfqhHvRTMNbWMg@mail.gmail.com>
Subject: Re: gcc/binutils bug suspected -- recommended actions?
From: =?UTF-8?B?0KHQtdGA0LPQtdC5INCv0L3QvtCy0LjRhw==?= <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 March 2013 02:36, Sergey Yanovich <ynvich@gmail.com> wrote:
> 3.8.2 ARM kernel panics on boot. BUG() log:
>
> Where should I look?

It wasn't gcc or ldd. I hit a BUG_ON() in kernel code.
