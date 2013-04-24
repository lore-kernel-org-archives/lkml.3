Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3DXKhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:37:46 -0400
Received: from ozlabs.org ([203.10.76.45]:41621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288Ab3DXKho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:37:44 -0400
From: Michael Neuling <mikey@neuling.org>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        gang.chen@asianux.com, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
In-reply-to: <51779941.8080403@linux.vnet.ibm.com>
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com>
Comments: In-reply-to Mike Qiu <qiudayu@linux.vnet.ibm.com>
   message dated "Wed, 24 Apr 2013 16:35:13 +0800."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Apr 2013 20:37:38 +1000
Message-ID: <30651.1366799858@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:

> 于 2013/4/24 16:31, Michael Ellerman 写道:
> > On Wed, Apr 24, 2013 at 04:22:53PM +0800, Mike Qiu wrote:
> >> Hi all
> >>
> >> I get an error message when I compile the source code in Power7 platform
> >> use the newest upstream kernel.
> > Hi Mike,
> >
> > It depends on what your .config is. What defconfig are you building?
> I just copy the config file from /boot/config.* to .config and use make
> menuconfig
> change nothing by manually, then save.

Can you post the resulting config here?

Do you have commit in your tree?
  commit 087aa036eb79f24b856893190359ba812b460f45
  Author: Chen Gang <gang.chen@asianux.com>
  powerpc: make additional room in exception vector area

Mikey
