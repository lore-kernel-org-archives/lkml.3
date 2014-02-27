Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaB0TTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:19:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:58688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaB0TTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:19:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 5/5] bug: Make BUG() call unreachable()
Date: Thu, 27 Feb 2014 20:19:47 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org> <201402261429.06553.arnd@arndb.de> <20140226145806.GA24150@thin>
In-Reply-To: <20140226145806.GA24150@thin>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402272019.47554.arnd@arndb.de>
X-Provags-ID: V02:K0:u1slykXed1/4uBF1DKdqBL3rwn27arSFkO49eW4SZI0
 TcF2QYxOhlPeR1utJDVYAeE3Ky6fnVw+4XPOA4uIomws2ZZ6rS
 BFrH6WKS0OwPuVFJuw+vsh13nd+lM2b7zkkNDXZTu1jcsZoMjc
 3czGJzzMCJ4uKeHN14MyEScgVmFhHLcGRgCCtOBYZm01n2tD/L
 +uI7Ksx6QdCgv/X+NvOC9W+sv2fIHay1DSDAeXMVmzI9HMjIU2
 7JHTKaOOZF5GfO2Z5qCEgORERjxhzdwFhQLhZWa0x7Us8BJ5+S
 e2esXb+i7bb6jmQtrGZbdmYtdMRCNTDrwS+2mBRBjyTnxjAn3j
 6nlpcQUsCFCb/6Ej5vMY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Josh Triplett wrote:
> This doesn't seem any different than compiling out assert() at runtime
> in a userspace program, given how the kernel uses BUG() and BUG_ON().
> I'd argue that adding unreachable() doesn't seem like it makes the
> current implementation of BUG() any worse; either way if you reach it
> you have a problem.

I think it's better to get a warning about undefined behavior than
to suppress that warning.

	Arnd
