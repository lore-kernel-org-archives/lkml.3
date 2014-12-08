Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaLHNio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:38:44 -0500
Received: from sym2.noone.org ([178.63.92.236]:54377 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaLHNin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:38:43 -0500
Date: Mon, 8 Dec 2014 14:38:40 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        santosh.shilimkar@ti.com
Subject: Re: [PATCH] drivers: Kconfig: Remove duplicate sourcing of soc folder
Message-ID: <20141208133840.GA10939@distanz.ch>
References: <1418045784-4602-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418045784-4602-1-git-send-email-pramod.gurav@smartplayin.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-08 at 14:36:24 +0100, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> Folder soc/ was sourced twice somehow. Remove duplicate entry.

I already sent a patch for this a while ago [1], though it wasn't
applied yet.

[1] http://thread.gmane.org/gmane.linux.kernel/1831623
