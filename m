Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3LEC1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:27:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3LEC1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:27:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: haver@linux.vnet.ibm.com
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
Date: Thu, 5 Dec 2013 03:27:25 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com> <1386080903-27160-2-git-send-email-haver@linux.vnet.ibm.com> <1386151347.7883.15.camel@oc7383187364.ibm.com>
In-Reply-To: <1386151347.7883.15.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050327.26152.arnd@arndb.de>
X-Provags-ID: V02:K0:XaZPGg4oeW6Vc8VPi4mQqEN/rzAQiygbIgcjVc4dcOU
 Bb1hH2HPtAlogEsw1m+Ktb2i3GmT5nSugyoQVExTx5VLcw05WU
 txCLiskSNKfGiSOI9vAJaihoIGxnVHy/j5kZ4OEwVhMJ2KI0kA
 PZVEKqUwqBu0Y4trk0wYHLH1k3Y1enfHs6VunxBZAkq49Ffz5C
 n634i8K2kErh6IoD8MwxJj3n4mqeMJE/VoiO/QkPZYxUg/x+6D
 b00YSv1JRw4ONY+Y3voQ4Glwb1CI/HexRMxT8IvN7kPLrrUIeu
 OTvaCj+2/wk31WlQmy32avJy0SFh7FcTyvVsg1dtfOfc/V1lDb
 /dwErKOfTIkbo4PZpegU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013, Frank Haverkamp wrote:
> Am Dienstag, den 03.12.2013, 15:28 +0100 schrieb Frank Haverkamp:
> > + */
> > +struct genwqe_mem {
> > +       unsigned long addr;
> > +       unsigned long size;
> > +       int direction;
> > +};
> > +
> > +#define GENWQE_PIN_MEM       _IOWR(GENWQE_IOC_CODE, 40, struct
> > genwqe_mem *)
> > +#define GENWQE_UNPIN_MEM      _IOWR(GENWQE_IOC_CODE, 41, struct
> > genwqe_mem *)
> > + 
> 
> Before someone comments on the unsigned long and the 32/64 bit issues
> with it. I need to fix that.

Also the extraneous '*' in the definitions.

	Arnd
