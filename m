Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaJLSRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:17:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:6566 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbaJLSR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:17:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,705,1406617200"; 
   d="scan'208";a="613294902"
Date: Sun, 12 Oct 2014 21:17:21 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Huewe <PeterHuewe@gmx.de>, keyrings@linux-nfs.org,
        jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [Ksummit-discuss] TPM MiniSummit @ LinuxCon Europe
Message-ID: <20141012181721.GB5495@intel.com>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

apologies for top-posting but which day/time/place is this going to be held?

/Jarkko

On Tue, Sep 23, 2014 at 09:42:33AM -0700, Andy Lutomirski wrote:
> On Sep 22, 2014 2:07 AM, "Peter Huewe" <PeterHuewe@gmx.de> wrote:
> >
> > Hi,
> >
> > I would like to 'invite' all interested parties in a short TPM minisummit where we can discuss the following hot topics of the TPM subsystem over a beer or two:
> >  - State of the TPM Subsystem
> >  - De-/Initialization Mess
> >  - Devm'ification
> >  - Testing
> >  - TPM 2.0 Support
> >  - Dependencies / interaction with other subsystems (e.g. keyring / IMA)
> >  - Status of old 1.1b TPM drivers, deprecation plans
> >  - ...
> >
> 
> I am unlikely to be there, but I have a feature request / food for thought:
> 
> Using a mandatory userspace daemon (e.g. trousers) for TPM access
> sucks.  Might it be possible to teach the kernel to handle context
> save and restore and let multiple processes open the device at once?
> Then a daemon wouldn't be necessary.
> 
> There would still be a need for some policy (e.g. who can clear the
> SRK), but that should be manageable.  Maybe there should be two device
> nodes.  /dev/tpm_unpriv would be fully virtualized for access by
> multiple processes, but it would only allow use of the key hierarchy
> and read access to PCRs.  /dev/tpm_priv would allow NV access, PCR
> writes, SRK clears, etc.
> 
> --Andy
> 
> >
> > Please register your interest by filling out this doodle
> >  http://doodle.com/q9ezcrivhqrktw6u
> >
> > I'm not sure if I can get any funding for the summit... but maybe I can arrange something.
> >
> >
> > Also I'm trying to bring along some TPM samples from my employer if possible.
> >
> >
> > Thanks
> > Peter
> >
> > p.s.: experienced kernel developers welcome :)
> > _______________________________________________
> > Ksummit-discuss mailing list
> > Ksummit-discuss@lists.linuxfoundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss
> 
> ------------------------------------------------------------------------------
> Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
> Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
> Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
> Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
> http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
