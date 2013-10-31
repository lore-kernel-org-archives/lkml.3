Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3JaMKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:10:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53689 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752145Ab3JaMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:10:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lv Zheng <lv.zheng@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for linux-3.8.
Date: Thu, 31 Oct 2013 13:22:11 +0100
Message-ID: <18963273.JtsE7nd0JW@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131031120850.GA17048@kroah.com>
References: <cover.1383181113.git.lv.zheng@intel.com> <2226874.g7cLvQ5SiE@vostro.rjw.lan> <20131031120850.GA17048@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 31, 2013 05:08:50 AM Greg Kroah-Hartman wrote:
> On Thu, Oct 31, 2013 at 12:39:21PM +0100, Rafael J. Wysocki wrote:
> > On Thursday, October 31, 2013 09:07:40 AM Lv Zheng wrote:
> > > There are bug-fixes for AML interpreter upstreamed, fixing some serious
> > > issues found in recent platforms.  These fixes make Linux AML interpreter
> > > more ACPI 2.0 ASL concept compliant.  Further AML interpreter fixes should
> > > be based on such improvements, thus they are good materials for stable.
> > > 
> > > This patch set can be safely applied to linux-3.8:
> > > commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200 upstream.
> > > 
> > > The patch set has passed build/boot tests on the following machines:
> > >   Dell Inspiron Mini 1010 (i386)
> > >   HP Compaq 8200 Elite SFF PC (x86-64)
> > > 
> > > Bob Moore (4):
> > >   ACPICA: Interpreter: Fix Store() when implicit conversion is not
> > >     possible.
> > >   ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and
> > >     BufferField refs.
> > >   ACPICA: Return error if DerefOf resolves to a null package element.
> > >   ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a
> > >     field.
> > 
> > Hi Greg,
> > 
> > Please take patches [1-4/4] for stable.
> 
> "Which" stable tree?
> 
> I don't do 3.8, it's long been end-of-life, although one company is
> trying to keep it alive, but that's not me.
> 
> I'm only handling 3.4, 3.10, and 3.11 stable trees right now, which
> one(s) should these be applied to?

3.10.x and 3.11.x then.

Lv, do the original mainline commits apply to these kernels?

Rafael

