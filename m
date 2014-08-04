Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaHDIEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:04:16 -0400
Received: from ozlabs.org ([103.22.144.67]:40025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaHDIEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:04:14 -0400
Date: Mon, 4 Aug 2014 18:04:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: linux-next: manual merge of the kvm-ppc tree with the kvm tree
Message-ID: <20140804180403.3cfdbadf@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/h_RVbw04083CzZ21vtPatpI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/h_RVbw04083CzZ21vtPatpI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
Documentation/virtual/kvm/api.txt between commit bf5590f37919 ("KVM:
Reformat KVM_SET_ONE_REG register documentation") from the kvm tree and
commit a0840240c0c6 ("KVM: PPC: Book3S: Fix LPCR one_reg interface")
from the kvm-ppc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/virtual/kvm/api.txt
index 68cda1fc3d52,a21ff2265c21..000000000000
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@@ -1797,151 -1777,123 +1800,152 @@@ and architecture specific registers. =
Ea
  and their own constants and width. To keep track of the implemented
  registers, find a list below:
 =20
 -  Arch  |       Register        | Width (bits)
 -        |                       |
 -  PPC   | KVM_REG_PPC_HIOR      | 64
 -  PPC   | KVM_REG_PPC_IAC1      | 64
 -  PPC   | KVM_REG_PPC_IAC2      | 64
 -  PPC   | KVM_REG_PPC_IAC3      | 64
 -  PPC   | KVM_REG_PPC_IAC4      | 64
 -  PPC   | KVM_REG_PPC_DAC1      | 64
 -  PPC   | KVM_REG_PPC_DAC2      | 64
 -  PPC   | KVM_REG_PPC_DABR      | 64
 -  PPC   | KVM_REG_PPC_DSCR      | 64
 -  PPC   | KVM_REG_PPC_PURR      | 64
 -  PPC   | KVM_REG_PPC_SPURR     | 64
 -  PPC   | KVM_REG_PPC_DAR       | 64
 -  PPC   | KVM_REG_PPC_DSISR     | 32
 -  PPC   | KVM_REG_PPC_AMR       | 64
 -  PPC   | KVM_REG_PPC_UAMOR     | 64
 -  PPC   | KVM_REG_PPC_MMCR0     | 64
 -  PPC   | KVM_REG_PPC_MMCR1     | 64
 -  PPC   | KVM_REG_PPC_MMCRA     | 64
 -  PPC   | KVM_REG_PPC_MMCR2     | 64
 -  PPC   | KVM_REG_PPC_MMCRS     | 64
 -  PPC   | KVM_REG_PPC_SIAR      | 64
 -  PPC   | KVM_REG_PPC_SDAR      | 64
 -  PPC   | KVM_REG_PPC_SIER      | 64
 -  PPC   | KVM_REG_PPC_PMC1      | 32
 -  PPC   | KVM_REG_PPC_PMC2      | 32
 -  PPC   | KVM_REG_PPC_PMC3      | 32
 -  PPC   | KVM_REG_PPC_PMC4      | 32
 -  PPC   | KVM_REG_PPC_PMC5      | 32
 -  PPC   | KVM_REG_PPC_PMC6      | 32
 -  PPC   | KVM_REG_PPC_PMC7      | 32
 -  PPC   | KVM_REG_PPC_PMC8      | 32
 -  PPC   | KVM_REG_PPC_FPR0      | 64
 +  Arch  |           Register            | Width (bits)
 +        |                               |
 +  PPC   | KVM_REG_PPC_HIOR              | 64
 +  PPC   | KVM_REG_PPC_IAC1              | 64
 +  PPC   | KVM_REG_PPC_IAC2              | 64
 +  PPC   | KVM_REG_PPC_IAC3              | 64
 +  PPC   | KVM_REG_PPC_IAC4              | 64
 +  PPC   | KVM_REG_PPC_DAC1              | 64
 +  PPC   | KVM_REG_PPC_DAC2              | 64
 +  PPC   | KVM_REG_PPC_DABR              | 64
 +  PPC   | KVM_REG_PPC_DSCR              | 64
 +  PPC   | KVM_REG_PPC_PURR              | 64
 +  PPC   | KVM_REG_PPC_SPURR             | 64
 +  PPC   | KVM_REG_PPC_DAR               | 64
 +  PPC   | KVM_REG_PPC_DSISR             | 32
 +  PPC   | KVM_REG_PPC_AMR               | 64
 +  PPC   | KVM_REG_PPC_UAMOR             | 64
 +  PPC   | KVM_REG_PPC_MMCR0             | 64
 +  PPC   | KVM_REG_PPC_MMCR1             | 64
 +  PPC   | KVM_REG_PPC_MMCRA             | 64
 +  PPC   | KVM_REG_PPC_MMCR2             | 64
 +  PPC   | KVM_REG_PPC_MMCRS             | 64
 +  PPC   | KVM_REG_PPC_SIAR              | 64
 +  PPC   | KVM_REG_PPC_SDAR              | 64
 +  PPC   | KVM_REG_PPC_SIER              | 64
 +  PPC   | KVM_REG_PPC_PMC1              | 32
 +  PPC   | KVM_REG_PPC_PMC2              | 32
 +  PPC   | KVM_REG_PPC_PMC3              | 32
 +  PPC   | KVM_REG_PPC_PMC4              | 32
 +  PPC   | KVM_REG_PPC_PMC5              | 32
 +  PPC   | KVM_REG_PPC_PMC6              | 32
 +  PPC   | KVM_REG_PPC_PMC7              | 32
 +  PPC   | KVM_REG_PPC_PMC8              | 32
 +  PPC   | KVM_REG_PPC_FPR0              | 64
 +          ...
 +  PPC   | KVM_REG_PPC_FPR31             | 64
 +  PPC   | KVM_REG_PPC_VR0               | 128
            ...
 -  PPC   | KVM_REG_PPC_FPR31     | 64
 -  PPC   | KVM_REG_PPC_VR0       | 128
 +  PPC   | KVM_REG_PPC_VR31              | 128
 +  PPC   | KVM_REG_PPC_VSR0              | 128
            ...
 -  PPC   | KVM_REG_PPC_VR31      | 128
 -  PPC   | KVM_REG_PPC_VSR0      | 128
 +  PPC   | KVM_REG_PPC_VSR31             | 128
 +  PPC   | KVM_REG_PPC_FPSCR             | 64
 +  PPC   | KVM_REG_PPC_VSCR              | 32
 +  PPC   | KVM_REG_PPC_VPA_ADDR          | 64
 +  PPC   | KVM_REG_PPC_VPA_SLB           | 128
 +  PPC   | KVM_REG_PPC_VPA_DTL           | 128
 +  PPC   | KVM_REG_PPC_EPCR              | 32
 +  PPC   | KVM_REG_PPC_EPR               | 32
 +  PPC   | KVM_REG_PPC_TCR               | 32
 +  PPC   | KVM_REG_PPC_TSR               | 32
 +  PPC   | KVM_REG_PPC_OR_TSR            | 32
 +  PPC   | KVM_REG_PPC_CLEAR_TSR         | 32
 +  PPC   | KVM_REG_PPC_MAS0              | 32
 +  PPC   | KVM_REG_PPC_MAS1              | 32
 +  PPC   | KVM_REG_PPC_MAS2              | 64
 +  PPC   | KVM_REG_PPC_MAS7_3            | 64
 +  PPC   | KVM_REG_PPC_MAS4              | 32
 +  PPC   | KVM_REG_PPC_MAS6              | 32
 +  PPC   | KVM_REG_PPC_MMUCFG            | 32
 +  PPC   | KVM_REG_PPC_TLB0CFG           | 32
 +  PPC   | KVM_REG_PPC_TLB1CFG           | 32
 +  PPC   | KVM_REG_PPC_TLB2CFG           | 32
 +  PPC   | KVM_REG_PPC_TLB3CFG           | 32
 +  PPC   | KVM_REG_PPC_TLB0PS            | 32
 +  PPC   | KVM_REG_PPC_TLB1PS            | 32
 +  PPC   | KVM_REG_PPC_TLB2PS            | 32
 +  PPC   | KVM_REG_PPC_TLB3PS            | 32
 +  PPC   | KVM_REG_PPC_EPTCFG            | 32
 +  PPC   | KVM_REG_PPC_ICP_STATE         | 64
 +  PPC   | KVM_REG_PPC_TB_OFFSET         | 64
 +  PPC   | KVM_REG_PPC_SPMC1             | 32
 +  PPC   | KVM_REG_PPC_SPMC2             | 32
 +  PPC   | KVM_REG_PPC_IAMR              | 64
 +  PPC   | KVM_REG_PPC_TFHAR             | 64
 +  PPC   | KVM_REG_PPC_TFIAR             | 64
 +  PPC   | KVM_REG_PPC_TEXASR            | 64
 +  PPC   | KVM_REG_PPC_FSCR              | 64
 +  PPC   | KVM_REG_PPC_PSPB              | 32
 +  PPC   | KVM_REG_PPC_EBBHR             | 64
 +  PPC   | KVM_REG_PPC_EBBRR             | 64
 +  PPC   | KVM_REG_PPC_BESCR             | 64
 +  PPC   | KVM_REG_PPC_TAR               | 64
 +  PPC   | KVM_REG_PPC_DPDES             | 64
 +  PPC   | KVM_REG_PPC_DAWR              | 64
 +  PPC   | KVM_REG_PPC_DAWRX             | 64
 +  PPC   | KVM_REG_PPC_CIABR             | 64
 +  PPC   | KVM_REG_PPC_IC                | 64
 +  PPC   | KVM_REG_PPC_VTB               | 64
 +  PPC   | KVM_REG_PPC_CSIGR             | 64
 +  PPC   | KVM_REG_PPC_TACR              | 64
 +  PPC   | KVM_REG_PPC_TCSCR             | 64
 +  PPC   | KVM_REG_PPC_PID               | 64
 +  PPC   | KVM_REG_PPC_ACOP              | 64
 +  PPC   | KVM_REG_PPC_VRSAVE            | 32
 +  PPC   | KVM_REG_PPC_LPCR              | 64
++  PPC   | KVM_REG_PPC_LPCR_64		| 64
 +  PPC   | KVM_REG_PPC_PPR               | 64
 +  PPC   | KVM_REG_PPC_ARCH_COMPAT       | 32
 +  PPC   | KVM_REG_PPC_DABRX             | 32
 +  PPC   | KVM_REG_PPC_WORT              | 64
 +  PPC   | KVM_REG_PPC_TM_GPR0           | 64
            ...
 -  PPC   | KVM_REG_PPC_VSR31     | 128
 -  PPC   | KVM_REG_PPC_FPSCR     | 64
 -  PPC   | KVM_REG_PPC_VSCR      | 32
 -  PPC   | KVM_REG_PPC_VPA_ADDR  | 64
 -  PPC   | KVM_REG_PPC_VPA_SLB   | 128
 -  PPC   | KVM_REG_PPC_VPA_DTL   | 128
 -  PPC   | KVM_REG_PPC_EPCR	| 32
 -  PPC   | KVM_REG_PPC_EPR	| 32
 -  PPC   | KVM_REG_PPC_TCR	| 32
 -  PPC   | KVM_REG_PPC_TSR	| 32
 -  PPC   | KVM_REG_PPC_OR_TSR	| 32
 -  PPC   | KVM_REG_PPC_CLEAR_TSR	| 32
 -  PPC   | KVM_REG_PPC_MAS0	| 32
 -  PPC   | KVM_REG_PPC_MAS1	| 32
 -  PPC   | KVM_REG_PPC_MAS2	| 64
 -  PPC   | KVM_REG_PPC_MAS7_3	| 64
 -  PPC   | KVM_REG_PPC_MAS4	| 32
 -  PPC   | KVM_REG_PPC_MAS6	| 32
 -  PPC   | KVM_REG_PPC_MMUCFG	| 32
 -  PPC   | KVM_REG_PPC_TLB0CFG	| 32
 -  PPC   | KVM_REG_PPC_TLB1CFG	| 32
 -  PPC   | KVM_REG_PPC_TLB2CFG	| 32
 -  PPC   | KVM_REG_PPC_TLB3CFG	| 32
 -  PPC   | KVM_REG_PPC_TLB0PS	| 32
 -  PPC   | KVM_REG_PPC_TLB1PS	| 32
 -  PPC   | KVM_REG_PPC_TLB2PS	| 32
 -  PPC   | KVM_REG_PPC_TLB3PS	| 32
 -  PPC   | KVM_REG_PPC_EPTCFG	| 32
 -  PPC   | KVM_REG_PPC_ICP_STATE | 64
 -  PPC   | KVM_REG_PPC_TB_OFFSET	| 64
 -  PPC   | KVM_REG_PPC_SPMC1	| 32
 -  PPC   | KVM_REG_PPC_SPMC2	| 32
 -  PPC   | KVM_REG_PPC_IAMR	| 64
 -  PPC   | KVM_REG_PPC_TFHAR	| 64
 -  PPC   | KVM_REG_PPC_TFIAR	| 64
 -  PPC   | KVM_REG_PPC_TEXASR	| 64
 -  PPC   | KVM_REG_PPC_FSCR	| 64
 -  PPC   | KVM_REG_PPC_PSPB	| 32
 -  PPC   | KVM_REG_PPC_EBBHR	| 64
 -  PPC   | KVM_REG_PPC_EBBRR	| 64
 -  PPC   | KVM_REG_PPC_BESCR	| 64
 -  PPC   | KVM_REG_PPC_TAR	| 64
 -  PPC   | KVM_REG_PPC_DPDES	| 64
 -  PPC   | KVM_REG_PPC_DAWR	| 64
 -  PPC   | KVM_REG_PPC_DAWRX	| 64
 -  PPC   | KVM_REG_PPC_CIABR	| 64
 -  PPC   | KVM_REG_PPC_IC	| 64
 -  PPC   | KVM_REG_PPC_VTB	| 64
 -  PPC   | KVM_REG_PPC_CSIGR	| 64
 -  PPC   | KVM_REG_PPC_TACR	| 64
 -  PPC   | KVM_REG_PPC_TCSCR	| 64
 -  PPC   | KVM_REG_PPC_PID	| 64
 -  PPC   | KVM_REG_PPC_ACOP	| 64
 -  PPC   | KVM_REG_PPC_VRSAVE	| 32
 -  PPC   | KVM_REG_PPC_LPCR	| 32
 -  PPC   | KVM_REG_PPC_LPCR_64	| 64
 -  PPC   | KVM_REG_PPC_PPR	| 64
 -  PPC   | KVM_REG_PPC_ARCH_COMPAT 32
 -  PPC   | KVM_REG_PPC_DABRX     | 32
 -  PPC   | KVM_REG_PPC_WORT      | 64
 -  PPC   | KVM_REG_PPC_TM_GPR0	| 64
 +  PPC   | KVM_REG_PPC_TM_GPR31          | 64
 +  PPC   | KVM_REG_PPC_TM_VSR0           | 128
            ...
 -  PPC   | KVM_REG_PPC_TM_GPR31	| 64
 -  PPC   | KVM_REG_PPC_TM_VSR0	| 128
 +  PPC   | KVM_REG_PPC_TM_VSR63          | 128
 +  PPC   | KVM_REG_PPC_TM_CR             | 64
 +  PPC   | KVM_REG_PPC_TM_LR             | 64
 +  PPC   | KVM_REG_PPC_TM_CTR            | 64
 +  PPC   | KVM_REG_PPC_TM_FPSCR          | 64
 +  PPC   | KVM_REG_PPC_TM_AMR            | 64
 +  PPC   | KVM_REG_PPC_TM_PPR            | 64
 +  PPC   | KVM_REG_PPC_TM_VRSAVE         | 64
 +  PPC   | KVM_REG_PPC_TM_VSCR           | 32
 +  PPC   | KVM_REG_PPC_TM_DSCR           | 64
 +  PPC   | KVM_REG_PPC_TM_TAR            | 64
 +        |                               |
 +  MIPS  | KVM_REG_MIPS_R0               | 64
            ...
 -  PPC   | KVM_REG_PPC_TM_VSR63	| 128
 -  PPC   | KVM_REG_PPC_TM_CR	| 64
 -  PPC   | KVM_REG_PPC_TM_LR	| 64
 -  PPC   | KVM_REG_PPC_TM_CTR	| 64
 -  PPC   | KVM_REG_PPC_TM_FPSCR	| 64
 -  PPC   | KVM_REG_PPC_TM_AMR	| 64
 -  PPC   | KVM_REG_PPC_TM_PPR	| 64
 -  PPC   | KVM_REG_PPC_TM_VRSAVE	| 64
 -  PPC   | KVM_REG_PPC_TM_VSCR	| 32
 -  PPC   | KVM_REG_PPC_TM_DSCR	| 64
 -  PPC   | KVM_REG_PPC_TM_TAR	| 64
 +  MIPS  | KVM_REG_MIPS_R31              | 64
 +  MIPS  | KVM_REG_MIPS_HI               | 64
 +  MIPS  | KVM_REG_MIPS_LO               | 64
 +  MIPS  | KVM_REG_MIPS_PC               | 64
 +  MIPS  | KVM_REG_MIPS_CP0_INDEX        | 32
 +  MIPS  | KVM_REG_MIPS_CP0_CONTEXT      | 64
 +  MIPS  | KVM_REG_MIPS_CP0_USERLOCAL    | 64
 +  MIPS  | KVM_REG_MIPS_CP0_PAGEMASK     | 32
 +  MIPS  | KVM_REG_MIPS_CP0_WIRED        | 32
 +  MIPS  | KVM_REG_MIPS_CP0_HWRENA       | 32
 +  MIPS  | KVM_REG_MIPS_CP0_BADVADDR     | 64
 +  MIPS  | KVM_REG_MIPS_CP0_COUNT        | 32
 +  MIPS  | KVM_REG_MIPS_CP0_ENTRYHI      | 64
 +  MIPS  | KVM_REG_MIPS_CP0_COMPARE      | 32
 +  MIPS  | KVM_REG_MIPS_CP0_STATUS       | 32
 +  MIPS  | KVM_REG_MIPS_CP0_CAUSE        | 32
 +  MIPS  | KVM_REG_MIPS_CP0_EPC          | 64
 +  MIPS  | KVM_REG_MIPS_CP0_CONFIG       | 32
 +  MIPS  | KVM_REG_MIPS_CP0_CONFIG1      | 32
 +  MIPS  | KVM_REG_MIPS_CP0_CONFIG2      | 32
 +  MIPS  | KVM_REG_MIPS_CP0_CONFIG3      | 32
 +  MIPS  | KVM_REG_MIPS_CP0_CONFIG7      | 32
 +  MIPS  | KVM_REG_MIPS_CP0_ERROREPC     | 64
 +  MIPS  | KVM_REG_MIPS_COUNT_CTL        | 64
 +  MIPS  | KVM_REG_MIPS_COUNT_RESUME     | 64
 +  MIPS  | KVM_REG_MIPS_COUNT_HZ         | 64
 =20
  ARM registers are mapped using the lower 32 bits.  The upper 16 of that
  is the register group type, or coprocessor number:
@@@ -2931,13 -2867,12 +2935,13 @@@ The fields in each entry are defined a
           this function/index combination
 =20
 =20
- 6. Capabilities that can be enabled
- -----------------------------------
+ 6. Capabilities that can be enabled on vCPUs
+ --------------------------------------------
 =20
 -There are certain capabilities that change the behavior of the virtual CP=
U when
 -enabled. To enable them, please see section 4.37. Below you can find a li=
st of
 -capabilities and what their effect on the vCPU is when enabling them.
 +There are certain capabilities that change the behavior of the virtual CP=
U or
 +the virtual machine when enabled. To enable them, please see section 4.37.
 +Below you can find a list of capabilities and what their effect on the vC=
PU or
 +the virtual machine is when enabling them.
 =20
  The following information is provided along with the description:
 =20
@@@ -3083,11 -3007,43 +3087,51 @@@ Parameters: args[0] is the XICS device=20
 =20
  This capability connects the vcpu to an in-kernel XICS device.
 =20
 +6.8 KVM_CAP_S390_IRQCHIP
 +
 +Architectures: s390
 +Target: vm
 +Parameters: none
 +
 +This capability enables the in-kernel irqchip for s390. Please refer to
 +"4.24 KVM_CREATE_IRQCHIP" for details.
+=20
+ 7. Capabilities that can be enabled on VMs
+ ------------------------------------------
+=20
+ There are certain capabilities that change the behavior of the virtual
+ machine when enabled. To enable them, please see section 4.37. Below
+ you can find a list of capabilities and what their effect on the VM
+ is when enabling them.
+=20
+ The following information is provided along with the description:
+=20
+   Architectures: which instruction set architectures provide this ioctl.
+       x86 includes both i386 and x86_64.
+=20
+   Parameters: what parameters are accepted by the capability.
+=20
+   Returns: the return value.  General error numbers (EBADF, ENOMEM, EINVA=
L)
+       are not detailed, but errors with specific meanings are.
+=20
+=20
+ 7.1 KVM_CAP_PPC_ENABLE_HCALL
+=20
+ Architectures: ppc
+ Parameters: args[0] is the sPAPR hcall number
+ 	    args[1] is 0 to disable, 1 to enable in-kernel handling
+=20
+ This capability controls whether individual sPAPR hypercalls (hcalls)
+ get handled by the kernel or not.  Enabling or disabling in-kernel
+ handling of an hcall is effective across the VM.  On creation, an
+ initial set of hcalls are enabled for in-kernel handling, which
+ consists of those hcalls for which in-kernel handlers were implemented
+ before this capability was implemented.  If disabled, the kernel will
+ not to attempt to handle the hcall, but will always exit to userspace
+ to handle it.  Note that it may not make sense to enable some and
+ disable others of a group of related hcalls, but KVM does not prevent
+ userspace from doing that.
+=20
+ If the hcall number specified is not one that has an in-kernel
+ implementation, the KVM_ENABLE_CAP ioctl will fail with an EINVAL
+ error.

--Sig_/h_RVbw04083CzZ21vtPatpI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3z55AAoJEMDTa8Ir7ZwVkTkP/2dsxyl65w/BLibhaGsGTkUs
mPVtHBMeE9yIYv2gtUZQJL60dGarjSbw0i4WhE3qKyGnpzsjXcudDuxNlHB1wkfe
sAwKs5K2ZA+JpI2JOW/YGtTWGy0nsyRq3vPdF2yp48/FjQBtLcgnzktY+zwYSEaY
AX+MPqSgaieIeT/7St8TYDLVU8KDGAhJXL3c7cpgDFdH2Wgy1XTYKXtaDEh9aw/x
Ew60GziG9XJEBF/dxhkyYJI1G3FE0P3k5PilvW/zTs7tVXU/vt4mQCSXxY7HmzE9
NSPzhra+dRIrCIBKmDeU3WLsEbaHi9kUjDdMTIkUxAlaafZ9265fHIRWmhFiqzct
mSkbrhtQIu/Pp0rO8H0pvnDR1hM+dUHIEP6G87evTgMAlp1uYHTq4PgntNQjmphx
IVRq4JjkJNJfCthTj+WeSJeMXb9jTBXGuKIJT7Y4sGBj/ImMc+ObN01ajuFLfdrl
gsbCOHN1v0zLJQXjvehofGMVYx4Hl1WIe7JUxvp24SW7uW6Yjc6nmpiEISOFWuJG
+PTjkDJ5PkvPeQwByRRwV/5IL2GtFA8+fBjOqEMzS25nj3BIdXqBYaVfAVYSRNt3
YoEEp0PIbkXOtA017zWgijygbNNcj4Qt1vWsVHaAHqCUfR4/xWvT+9/mQR0TaC5T
EDAZaFbE5UoFZqF3thhe
=LRoQ
-----END PGP SIGNATURE-----

--Sig_/h_RVbw04083CzZ21vtPatpI--
