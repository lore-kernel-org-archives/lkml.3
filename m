Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbaFSWmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:42:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35212 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaFSWmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:42:24 -0400
Message-ID: <53A36745.4060200@zytor.com>
Date: Thu, 19 Jun 2014 15:42:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86,vdso: Restore a bunch of section headers
References: <cover.1403129369.git.luto@amacapital.net>
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 03:59 PM, Andy Lutomirski wrote:
> This series makes me sad.  It brings the 64-bit vdso back above 4kB,
> like it was in 3.15.  It's also just silly, but it seems to be
> needed to keep binutils happy when debugging the vdso.

Oh well... it is only a single page across the entire kernel... there
are worse things in the world.

	-hpa


