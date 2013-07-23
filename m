Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3GWIrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:47:15 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:41687 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3GWIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
References: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
Date: Tue, 23 Jul 2013 18:47:08 +1000
Message-ID: <CAPM=9twg7GyUxdNOn=1SqGaEJO7nsLp2X=xwoCxX8ypAUBKdSg@mail.gmail.com>
Subject: Re: Unsupported DisplayLink (udl or udlfb module)
From: Dave Airlie <airlied@gmail.com>
To: Paolo Bolzoni <paolo.bolzoni.brown@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 10:58 PM, Paolo Bolzoni
<paolo.bolzoni.brown@gmail.com> wrote:
> Dear kernel list,
> I bought a DVI to VGA adapter[0] hoping to make it work with the
> modules udl or udlfb. The program lsusb does recognize it as a
> DisplayLink:

USB3 devices are competely different and not supported.

Dave.
