Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3KTPqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:46:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3KTPqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:46:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/7] mtd: nand: davinci: extend description of bindings
Date: Wed, 20 Nov 2013 16:46:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
References: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com> <1384960945-14528-7-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384960945-14528-7-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201311201646.21435.arnd@arndb.de>
X-Provags-ID: V02:K0:n3zYvlMhIufRJFVaKzYdetgrhKYR3ekt8hHU63N7ypr
 k6s+yb5PbWfQ/e9DSd61ZIFue6/cU5Jm/ce+GMwAd7kEfUMzb/
 +GPXg0nnMI4/SCCd4hPmM1fK0wF3hcsK7Z6Rwa6p+fnl7D5YQ3
 idPqbS3m1YjkiehVQdaccgofV1oLcs14SJKfWIP69akysqOD2f
 oXGq9vWy8shSubIcJgpJDkqRmHyVBUhWdK1+5D9XZPoq9J3a56
 103kiwd2nQ4xlkXURyU4Q7tCbSFRBVh+leEWeSIC9fKDI0gaQu
 UCBs3mc4zRqU/priBxw/rtzy0Cha5ZqKFUXM0+TO+9sBr/Lvbx
 L40D+EqyMOydv7Dtrb6w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013, Ivan Khoronzhuk wrote:
> Extend bindings for davinci_nand driver to be more clear.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  .../devicetree/bindings/mtd/davinci-nand.txt       |   77 ++++++++++++++------
>  1 file changed, 54 insertions(+), 23 deletions(-)

Hi Ivan,

The changes look good to me, but please clarify in the changeset description
above whether this is a backwards-compatible change, a clarification without
semantic changes, or an incompatible change (which should be avoided).

	Arnd
